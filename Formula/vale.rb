class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.4.0.tar.gz"
  sha256 "d99aeea5d0e93a96088f849db05520f7b531f211d158e9538a46eb2ca7931f3e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "827b7a9db4c10b450ce8d93cd616898778010282e018afeb1aa67c7b68d3e76e" => :catalina
    sha256 "16361505905889e26116b5ab760afb77dbdd6305edadffa13272943977e072bb" => :mojave
    sha256 "01b54b568e07f89a5c95c8b3ffba064f5274cea885304e57589d3659a6924f23" => :high_sierra
  end

  depends_on "go" => :build

  def install
    flags = "-X main.version=#{version} -s -w"
    system "go", "build", "-ldflags=#{flags}", "-o", "#{bin}/#{name}"
  end

  test do
    mkdir_p "styles/demo"
    (testpath/"styles/demo/HeadingStartsWithCapital.yml").write <<~EOS
      extends: capitalization
      message: "'%s' should be in title case"
      level: warning
      scope: heading.h1
      match: $title
    EOS

    (testpath/"vale.ini").write <<~EOS
      StylesPath = styles
      [*.md]
      BasedOnStyles = demo
    EOS

    (testpath/"document.md").write("# heading is not capitalized")

    output = shell_output("#{bin}/vale --config=#{testpath}/vale.ini #{testpath}/document.md 2>&1")
    assert_match("✖ 0 errors, 1 warning and 0 suggestions in 1 file.", output)
  end
end
