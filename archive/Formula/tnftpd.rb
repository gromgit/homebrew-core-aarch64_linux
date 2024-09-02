class Tnftpd < Formula
  desc "NetBSD's FTP server"
  homepage "https://cdn.netbsd.org/pub/NetBSD/misc/tnftp/"
  url "https://cdn.netbsd.org/pub/NetBSD/misc/tnftp/tnftpd-20200704.tar.gz"
  mirror "https://www.mirrorservice.org/sites/ftp.netbsd.org/pub/NetBSD/misc/tnftp/tnftpd-20200704.tar.gz"
  sha256 "92de915e1b4b7e4bd403daac5d89ce67fa73e49e8dda18e230fa86ee98e26ab7"

  livecheck do
    url :homepage
    regex(/href=.*?tnftpd[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/tnftpd"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "4ec82b3a09201a8562d1ff89fc0e7af03740566ccb1e4e93429f133e0ef07bdc"
  end

  uses_from_macos "bison" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"

    sbin.install "src/tnftpd" => "ftpd"
    man8.install "src/tnftpd.man" => "ftpd.8"
    man5.install "src/ftpusers.man" => "ftpusers.5"
    man5.install "src/ftpd.conf.man" => "ftpd.conf.5"
    etc.install "examples/ftpd.conf"
    etc.install "examples/ftpusers"
    prefix.install_metafiles
  end

  def caveats
    <<~EOS
      You may need super-user privileges to run this program properly. See the man
      page for more details.
    EOS
  end

  test do
    # Errno::EIO: Input/output error @ io_fillbuf - fd:5 /dev/pts/0
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    # running a whole server, connecting, and so forth is a bit clunky and hard
    # to write properly so...
    require "pty"
    require "expect"

    PTY.spawn "#{sbin}/ftpd -x" do |input, _output, _pid|
      str = input.expect(/ftpd: illegal option -- x/)
      assert_match "ftpd: illegal option -- x", str[0]
    end
  end
end
