class Fdclone < Formula
  desc "Console-based file manager"
  homepage "https://hp.vector.co.jp/authors/VA012337/soft/fd/"
  url "http://www.unixusers.net/src/fdclone/FD-3.01j.tar.gz"
  sha256 "fe5bb67eb670dcdb1f7368698641c928523e2269b9bee3d13b3b77565d22a121"

  livecheck do
    url :homepage
    regex(%r{href=.*?\./FD[._-]v?(\d+(?:\.\d+)+[a-z]?)\.t}i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fdclone"
    sha256 aarch64_linux: "781573e4a3c934907241a8ffd6af46b431d4fa352d2a6a4f0a1b9a22167b8e1a"
  end

  depends_on "nkf" => :build

  uses_from_macos "ncurses"

  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/86107cf/fdclone/3.01b.patch"
    sha256 "c4159db3052d7e4abec57ca719ff37f5acff626654ab4c1b513d7879dcd1eb78"
  end

  def install
    ENV.deparallelize
    system "make", "PREFIX=#{prefix}", "all"
    system "make", "MANTOP=#{man}", "install"

    %w[README FAQ HISTORY LICENSES TECHKNOW ToAdmin].each do |file|
      system "nkf", "-w", "--overwrite", file
      prefix.install "#{file}.eng" => file
      prefix.install file => "#{file}.ja"
    end

    pkgshare.install "_fdrc" => "fd2rc.dist"
  end

  def caveats
    <<~EOS
      To install the initial config file:
          install -c -m 0644 #{opt_pkgshare}/fd2rc.dist ~/.fd2rc
      To set application messages to Japanese, edit your .fd2rc:
          MESSAGELANG="ja"
    EOS
  end
end
