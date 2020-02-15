class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.15.1.tar.gz"
  sha256 "564d1b4afd44ed2e4d8095f95f5a49c08c321cd4074417b500076c966248aeea"

  bottle do
    cellar :any_skip_relocation
    sha256 "1021dd0ad20b1b57c0428db95a3d49abbb463dd2b3f38314a8f843bc826135a1" => :catalina
    sha256 "34e11e488e8356aff8fa5587c37360c42f1e2a2090d9a16b292d64d38bc45f44" => :mojave
    sha256 "475956ba4841331bd5930c3dbad760933d03260abdb05343ec2409ef3e0619db" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"test.md").write <<~EOS
      _lorem_ **ipsum** dolor **sit** _amet_
    EOS
    output = shell_output("#{bin}/mdcat --no-colour test.md")
    assert_match "lorem ipsum dolor sit amet", output
  end
end
