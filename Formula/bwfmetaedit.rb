class Bwfmetaedit < Formula
  desc "Tool for embedding, validating, and exporting BWF file metadata"
  homepage "https://mediaarea.net/BWFMetaEdit"
  url "https://mediaarea.net/download/binary/bwfmetaedit/21.07/BWFMetaEdit_CLI_21.07_GNU_FromSource.tar.bz2"
  sha256 "7b55d9c6df989a3cbff2bb2c9a18b0b0f3a80fa716539a160d612194906d94f2"
  license "0BSD"

  livecheck do
    url "https://mediaarea.net/BWFMetaEdit/Download/Source"
    regex(/href=.*?bwfmetaedit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3e74719411cb950866e9eec2b40fb5404238b6036a4a401785eb4cd1db220a9e"
    sha256 cellar: :any_skip_relocation, big_sur:       "1dbda1bf33cccd0b42ce0833f84c7f0a6a03162adde2650ecbd55cde00a89a8f"
    sha256 cellar: :any_skip_relocation, catalina:      "f8fc7ea2c57a3eaa0a247cbce5ae47839efc7ef098f3333d34f0d5628250fef2"
    sha256 cellar: :any_skip_relocation, mojave:        "8c0514552045937ff4ed9d27073ffcd9e4516b44fea073eddd11729ac8fe2c7e"
    sha256 cellar: :any_skip_relocation, high_sierra:   "bc8b768a4849b8c3740b18becc861fac1cde2e5294662dcd6e5c5697b91b15a2"
  end

  def install
    cd "Project/GNU/CLI" do
      system "./configure",  "--disable-debug", "--prefix=#{prefix}"
      system "make", "install"
    end
  end

  test do
    pipe_output("#{bin}/bwfmetaedit --out-tech", test_fixtures("test.wav"))
  end
end
