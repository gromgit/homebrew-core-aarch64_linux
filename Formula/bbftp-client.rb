class BbftpClient < Formula
  desc "Secure file transfer software, optimized for large files"
  homepage "http://software.in2p3.fr/bbftp/"
  url "http://software.in2p3.fr/bbftp/dist/bbftp-client-3.2.1.tar.gz"
  sha256 "4000009804d90926ad3c0e770099874084fb49013e8b0770b82678462304456d"
  license "GPL-2.0-or-later"
  revision 3

  livecheck do
    url "http://software.in2p3.fr/bbftp/download.html"
    regex(/href=.*?bbftp-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/bbftp-client"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "86fc23c6248cf35b4c52b17f1412850ce5c2020019f4bb9d5d3f3e710699edb1"
  end

  uses_from_macos "zlib"

  def install
    # Fix ntohll errors; reported 14 Jan 2015.
    ENV.append_to_cflags "-DHAVE_NTOHLL" if OS.mac?

    cd "bbftpc" do
      system "./configure", "--disable-debug",
                            "--disable-dependency-tracking",
                            "--without-ssl",
                            "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/bbftp", "-v"
  end
end
