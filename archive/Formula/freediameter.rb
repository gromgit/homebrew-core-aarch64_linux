class Freediameter < Formula
  desc "Open source Diameter (Authentication) protocol implementation"
  homepage "http://www.freediameter.net"
  url "http://www.freediameter.net/hg/freeDiameter/archive/1.5.0.tar.gz"
  sha256 "2500f75b70d428ea75dd25eedcdddf8fb6a8ea809b02c82bf5e35fe206cbbcbc"
  license "BSD-3-Clause"
  head "http://www.freediameter.net/hg/freeDiameter", using: :hg

  livecheck do
    url "http://www.freediameter.net/hg/freeDiameter/json-tags"
    regex(/["']tag["']:\s*?["']v?(\d+(?:\.\d+)+)["']/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/freediameter"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5e8969165591c4d19a3de9bf4174da54042a8957a627b91e38c0b23a24642a8b"
  end

  depends_on "cmake" => :build
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "libidn"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args, "-DDEFAULT_CONF_PATH=#{etc}",
                      "-DDISABLE_SCTP=ON"
      system "make"
      system "make", "install"
    end

    doc.install Dir["doc/*"]
    pkgshare.install "contrib"
  end

  def post_install
    return if File.exist?(etc/"freeDiameter.conf")

    cp doc/"freediameter.conf.sample", etc/"freeDiameter.conf"
  end

  def caveats
    <<~EOS
      To configure freeDiameter, edit #{etc}/freeDiameter.conf to taste.

      Sample configuration files can be found in #{doc}.

      For more information about freeDiameter configuration options, read:
        http://www.freediameter.net/trac/wiki/Configuration

      Other potentially useful files can be found in #{opt_pkgshare}/contrib.
    EOS
  end

  plist_options startup: true

  service do
    run opt_bin/"freeDiameterd"
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/freeDiameterd --version")
  end
end
