class Nspr < Formula
  desc "Platform-neutral API for system-level and libc-like functions"
  homepage "https://hg.mozilla.org/projects/nspr"
  url "https://archive.mozilla.org/pub/nspr/releases/v4.35/src/nspr-4.35.tar.gz"
  sha256 "7ea3297ea5969b5d25a5dd8d47f2443cda88e9ee746301f6e1e1426f8a6abc8f"
  license "MPL-2.0"

  livecheck do
    url "https://ftp.mozilla.org/pub/nspr/releases/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/nspr"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "7af9d2db9314b43f5c0a2fb62b6bc649c5c66480c311733c6744b0be6ceb1fb3"
  end

  def install
    ENV.deparallelize
    cd "nspr" do
      args = %W[
        --disable-debug
        --prefix=#{prefix}
        --enable-strip
        --with-pthreads
        --enable-ipv6
        --enable-macos-target=#{MacOS.version}
        --enable-64bit
      ]
      system "./configure", *args

      if OS.mac?
        # Remove the broken (for anyone but Firefox) install_name
        inreplace "config/autoconf.mk", "-install_name @executable_path/$@ ", "-install_name #{lib}/$@ "
      end

      system "make"
      system "make", "install"

      (bin/"compile-et.pl").unlink
      (bin/"prerr.properties").unlink
    end
  end

  test do
    system "#{bin}/nspr-config", "--version"
  end
end
