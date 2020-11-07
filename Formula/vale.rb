class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.6.1.tar.gz"
  sha256 "b264194b11fa6c93c8bf05ba168b4e964ea7bb035caf7b1531c90da21ed7a829"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "6310362997367ccedc39d0b82ee01934f5328e21fd662fe863a4f26bc396803e" => :catalina
    sha256 "f2f68ce0abda80a363016b6176f25c02c5d05f7e4dbf6176d9c6a086d22a3d54" => :mojave
    sha256 "12bbf745db0b7dba4dc4c624cb62fb8bddfc0a0856834c137205fd4968094f51" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}"
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
    assert_match(/✖ .*0 errors.*, .*1 warning.* and .*0 suggestions.* in 1 file\./, output)
  end
end
