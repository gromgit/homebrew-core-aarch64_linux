class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://github.com/rdiff-backup/rdiff-backup/releases/download/v2.0.0/rdiff-backup-2.0.0.tar.gz"
  sha256 "5b0e7afec624862c01acb5470da0519d8945af12819a4303a13ba82b654d8ee8"

  bottle do
    cellar :any
    sha256 "227cf94d42d42ef7750368f1571608e4c3bdab841ee22d850bdd1dfa0378a90a" => :catalina
    sha256 "576744615d68954e2389f3e7aaa36b83e6ded022d8ba57fc955b5e239fd029a4" => :mojave
    sha256 "dfa0b44633e5aab9797c1c71ee8cf36715178b3607cff0c914145743c402aa82" => :high_sierra
  end

  depends_on "librsync"
  depends_on "python@3.8"

  def install
    ENV["ARCHFLAGS"] = "-arch x86_64"
    system "python3", "setup.py", "build", "--librsync-dir=#{prefix}"
    libexec.install Dir["build/lib.macosx*/rdiff_backup"]
    libexec.install Dir["build/scripts-*/*"]
    man1.install Dir["docs/*.1"]
    bin.install_symlink Dir["#{libexec}/rdiff-backup*"]
  end

  test do
    system "#{bin}/rdiff-backup", "--version"
  end
end
