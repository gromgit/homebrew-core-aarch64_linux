class Pdfcrack < Formula
  desc "PDF files password cracker"
  homepage "https://pdfcrack.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pdfcrack/pdfcrack/pdfcrack-0.19/pdfcrack-0.19.tar.gz"
  sha256 "3115206998b7cddf13971dd4b50946c077fc96e220aca1c0734798d907a2c0ed"
  license "GPL-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/pdfcrack"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "3b2120020d206b0e27568b46c52e39757f6031fade6e18299ae89fea39d0639f"
  end

  def install
    system "make", "all"
    bin.install "pdfcrack"
  end

  test do
    system "#{bin}/pdfcrack", "--version"
  end
end
