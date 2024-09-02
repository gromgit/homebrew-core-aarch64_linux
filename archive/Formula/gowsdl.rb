class Gowsdl < Formula
  desc "WSDL2Go code generation as well as its SOAP proxy"
  homepage "https://github.com/hooklift/gowsdl"
  url "https://github.com/hooklift/gowsdl.git",
      tag:      "v0.5.0",
      revision: "51f3ef6c0e8f41ed1bdccce4c04e86b6769da313"
  license "MPL-2.0"
  head "https://github.com/hooklift/gowsdl.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/gowsdl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "a2a5126ee910706f5213e47595f87226a0b939518d45ff57f9b9f9330db815c6"
  end

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "build/gowsdl"
  end

  test do
    system "#{bin}/gowsdl"
  end
end
