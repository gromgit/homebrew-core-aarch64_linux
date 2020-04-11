class Mdcat < Formula
  desc "Show markdown documents on text terminals"
  homepage "https://github.com/lunaryorn/mdcat"
  url "https://github.com/lunaryorn/mdcat/archive/mdcat-0.16.0.tar.gz"
  sha256 "32dd1332d547f18bfb7d295dff957997464df6e62a3fbe97468332e742ceb5bc"

  bottle do
    cellar :any_skip_relocation
    sha256 "a5491d6172a322a51a4eafcb3ac59620df2cd72f7275c2876b09b641a905f3ad" => :catalina
    sha256 "fafdec233d7c9e74dc1fab3d1f48528bae8f66b8895e542c9727f9224759d102" => :mojave
    sha256 "63d825dc7bda8abcf36dbdeea3f63e728aba59defde2ce34c68f36f4a8643ac7" => :high_sierra
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
