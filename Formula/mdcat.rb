class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.22.2.tar.gz"
  sha256 "92102c448c1742aa69604817d7d209c69ce1db5261cb6d8f0bb98cdc6c4f02f9"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "f0bff22df0952a61a78e6e317e30860bb568c43ccf30b4b7f469311435f739db" => :big_sur
    sha256 "efb63962746712d38e859844a408e34f14144fb8d1c1e118a67060206560232e" => :arm64_big_sur
    sha256 "8765ebb14e200949ef0cc2fa572aef8a84eea0c7b5b5b89ed6b8e2ee1896c4a1" => :catalina
    sha256 "3d46736eb02798a8d9dc986bcf025d89b3e5c19bc4bf0900eab9ea7c7aafb519" => :mojave
    sha256 "74d85385506c912257d520d7425ef9770cb7da76cd0edb1da1f4f22abeebaa2c" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
