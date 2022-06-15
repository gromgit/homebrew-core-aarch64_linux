class Odt2txt < Formula
  desc "Convert OpenDocument files to plain text"
  homepage "https://github.com/dstosberg/odt2txt/"
  url "https://github.com/dstosberg/odt2txt/archive/v0.5.tar.gz"
  sha256 "23a889109ca9087a719c638758f14cc3b867a5dcf30a6c90bf6a0985073556dd"
  license "GPL-2.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/odt2txt"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "5c2a15057e12c3a3c2ae1eadf8a90a017fa4b4d6c13d8b3746c394a1c5b598bb"
  end

  uses_from_macos "zlib"

  resource "sample" do
    url "https://github.com/Turbo87/odt2txt/raw/samples/samples/sample-1.odt"
    sha256 "78a5b17613376e50a66501ec92260d03d9d8106a9d98128f1efb5c07c8bfa0b2"
  end

  def install
    system "make", "install", "DESTDIR=#{prefix}"
  end

  test do
    resources.each do |r|
      r.fetch
      system "#{bin}/odt2txt", r.cached_download
    end
  end
end
