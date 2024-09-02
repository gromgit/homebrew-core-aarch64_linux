class Rsnapshot < Formula
  desc "File system snapshot utility (based on rsync)"
  homepage "https://www.rsnapshot.org/"
  url "https://github.com/rsnapshot/rsnapshot/releases/download/1.4.5/rsnapshot-1.4.5.tar.gz"
  sha256 "10b75e01ca25511e8266aacd495531975ad1a8ad556216b6a57c76d028b38242"
  license "GPL-2.0-or-later"
  head "https://github.com/rsnapshot/rsnapshot.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rsnapshot"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "c251b106970618b09f368f78f44da907516918442997df35852199396cafe966"
  end

  uses_from_macos "rsync" => :build

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/rsnapshot", "--version"
  end
end
