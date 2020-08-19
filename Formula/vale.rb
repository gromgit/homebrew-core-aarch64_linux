class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.3.3.tar.gz"
  sha256 "97affef6b079a6b67ee8f5f94d5bd1e698dc41676a9bdf53e80b290801a8c648"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "79b99f9dcc0576a87e827b9ff23cbb1f6810625760fe728200fa3a5d7a6beabd" => :catalina
    sha256 "3ac5e92ca866ad5d6847e7883a3f69f6d99651b0ccde5194f590e7038f42e5aa" => :mojave
    sha256 "ac0e948f7e433da2193d704e9d9d0d9a3bab92e833af45696334ff1073b21f11" => :high_sierra
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
