class Cfv < Formula
  desc "Test and create various files (e.g., .sfv, .csv, .crc., .torrent)"
  homepage "https://cfv.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/cfv/cfv/1.18.3/cfv-1.18.3.tar.gz"
  sha256 "ff28a8aa679932b83eb3b248ed2557c6da5860d5f8456ffe24686253a354cff6"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cfv"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "2b0e26746fbb4d3363337d8d1e5af2553c0ef925846845f38bb12b7ae8763936"
  end

  def install
    system "make", "prefix=#{prefix}", "mandir=#{man}", "install"
  end

  test do
    (testpath/"test/test.txt").write "Homebrew!"
    cd "test" do
      system bin/"cfv", "-t", "sha1", "-C", "test.txt"
      assert_predicate Pathname.pwd/"test.sha1", :exist?
      assert_match "9afe8b4d99fb2dd5f6b7b3e548b43a038dc3dc38", File.read("test.sha1")
    end
  end
end
