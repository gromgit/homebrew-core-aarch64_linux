class Aide < Formula
  desc "File and directory integrity checker"
  homepage "https://aide.github.io/"
  url "https://github.com/aide/aide/releases/download/v0.17.3/aide-0.17.3.tar.gz"
  sha256 "a2eb1883cafaad056fbe43ee1e8ae09fd36caa30a0bc8edfea5d47bd67c464f8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "2a468e922032499a269dad94fa2a0829a21162eb940878f9a89d42050c3b6bac"
    sha256 cellar: :any, big_sur:       "efbbed870a2a86334ddc446e011f9ad8a14bae9993c3997b9f4422ac5f186c79"
    sha256 cellar: :any, catalina:      "39786e317a4c34c485b8d7612043f22c8885aa7590231fa0b625359decb46e29"
    sha256 cellar: :any, mojave:        "15f55f6bf54d6c03e714bb8db81d25f482b6f3eb8b8a0613992e06a328434fb7"
  end

  head do
    url "https://github.com/aide/aide.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "pcre"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    # use sdk's strnstr instead
    ENV.append_to_cflags "-DHAVE_STRNSTR"

    system "sh", "./autogen.sh" if build.head?

    args = %W[
      --disable-lfs
      --disable-static
      --with-zlib
      --sysconfdir=#{etc}
      --prefix=#{prefix}
    ]
    on_macos do
      args << "--with-curl"
    end
    on_linux do
      args << "--with-curl=" + Formula["curl"].prefix
    end

    system "./configure", *args

    system "make", "install"
  end

  test do
    (testpath/"aide.conf").write <<~EOS
      database_in = file:/var/lib/aide/aide.db
      database_out = file:/var/lib/aide/aide.db.new
      database_new = file:/var/lib/aide/aide.db.new
      gzip_dbout = yes
      report_summarize_changes = yes
      report_grouped = yes
      log_level = info
      database_attrs = sha256
      /etc p+i+u+g+sha256
    EOS
    system "#{bin}/aide", "--config-check", "-c", "aide.conf"
  end
end
