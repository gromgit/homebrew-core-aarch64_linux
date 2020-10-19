class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.22.1.tar.gz"
  sha256 "b14846542fb8b60ac0235b399136372df7569aa59ed63f3faf88ff7a485abe5f"
  license "MPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c609c9f35779be95823935df676648969795f55c4c73d7767fdb210e15e41d7" => :catalina
    sha256 "7285471f52c43c0a8f761a04ee2e4b32538d223fc8793345041eb45de060cba3" => :mojave
    sha256 "dfbca3e7c6197fa9d668d047f85842c9093a1a00bf7fe0e4db99d8d5d1c65f7e" => :high_sierra
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
