class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.8.1.tar.gz"
  sha256 "2d8575fc2ad64feba22b2f3befe94494d4019a80b5a0c0cf652d48858be60147"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "745913cb2e9da1038db2a46881747f00258cd28179cd627d04648bf589cf5c76" => :big_sur
    sha256 "51c249ac9681064a91896cd3a460d4e69304e1c10bfbb9e0a7874f1c5a2d5fc7" => :arm64_big_sur
    sha256 "32c61a7b5564ccfe8d23c78323b1f4f9f15d3cbbcd059620fba717955e2dc5d3" => :catalina
    sha256 "1b6e648f69ff63f232e2bb1a4288c256f29daa5b455304de1110ed3ca5531f03" => :mojave
  end

  depends_on "go" => :build

  def install
    ldflags = "-X main.version=#{version} -s -w"
    system "go", "build", *std_go_args, "-ldflags=#{ldflags}", "./cmd/vale"
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
