class Gearman < Formula
  desc "Application framework to farm out work to other machines or processes"
  homepage "http://gearman.org/"
  url "https://github.com/gearman/gearmand/releases/download/1.1.19.1/gearmand-1.1.19.1.tar.gz"
  sha256 "8ea6e0d16a0c924e6a65caea8a7cd49d3840b9256d440d991de4266447166bfb"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4345a6e4694a633cf44f98f0c050248f8c8361c02020eab19c695b3ec41cf82d"
    sha256 cellar: :any,                 arm64_big_sur:  "7ad3a612fb8b53340c453d57a576fe7d90d4c9e48cab54e743125f62158e200e"
    sha256 cellar: :any,                 monterey:       "80d89d4c584effcf7ca5040020682b75bcacdb564529a2cda03481629935e0f7"
    sha256 cellar: :any,                 big_sur:        "3aceb32f55d94d805262cd0052d79eba3c6475ea3fe109a1f78bac0194352e67"
    sha256 cellar: :any,                 catalina:       "293651e8e5851227f896dcd2f23eadcf4dd20f96b96b4584311f2483e64f4c41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "588f76c78956e298d289d89895ee0d8b871d396bc76eb80c6060c9e0af7532e4"
  end

  depends_on "pkg-config" => :build
  depends_on "sphinx-doc" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on "libmemcached"

  uses_from_macos "gperf" => :build
  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" # for libuuid
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    # Work around "error: no member named 'signbit' in the global namespace"
    # encountered when trying to detect boost regex in configure
    if MacOS.version == :high_sierra
      ENV.delete("HOMEBREW_SDKROOT")
      ENV.delete("SDKROOT")
    end

    # https://bugs.launchpad.net/gearmand/+bug/1368926
    Dir["tests/**/*.cc", "libtest/main.cc"].each do |test_file|
      next unless /std::unique_ptr/.match?(File.read(test_file))

      inreplace test_file, "std::unique_ptr", "std::auto_ptr"
    end

    args = %W[
      --prefix=#{prefix}
      --localstatedir=#{var}
      --disable-silent-rules
      --disable-dependency-tracking
      --disable-cyassl
      --disable-hiredis
      --disable-libdrizzle
      --disable-libpq
      --disable-libtokyocabinet
      --disable-ssl
      --enable-libmemcached
      --with-boost=#{Formula["boost"].opt_prefix}
      --with-memcached=#{Formula["memcached"].opt_bin}/memcached
      --with-sqlite3
      --without-mysql
      --without-postgresql
    ]

    ENV.append_to_cflags "-DHAVE_HTONLL"

    (var/"log").mkpath
    system "./configure", *args
    system "make", "install"
  end

  service do
    run opt_sbin/"gearmand"
  end

  test do
    assert_match(/gearman\s*Error in usage/, shell_output("#{bin}/gearman --version 2>&1", 1))
  end
end
