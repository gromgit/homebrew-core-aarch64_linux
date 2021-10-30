class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.12.0.tar.gz"
  sha256 "4ba37922755265ccfada534b98721903a77768e9bc9db67d028354c576d075b0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1ca444ff09be2f84f8f138a5e5335fd21e8b3b714cf310042296b1a397e458a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1379ee71c957874519a28330755dbce085730365c83af3fa100985fceb3c19ba"
    sha256 cellar: :any_skip_relocation, monterey:       "d5b12ae7d9cb5cb9bcb12a2f5c663dbcf160e9f5042f5b07ecc51242911987b5"
    sha256 cellar: :any_skip_relocation, big_sur:        "3340404b8d0b7404aeb1c43bbc6005b38abd20045c23ced68c1f70cb4517a594"
    sha256 cellar: :any_skip_relocation, catalina:       "84063b9e9800984436627780dc69821e4fffe714e8b65484897be52e764fa6f7"
    sha256 cellar: :any_skip_relocation, mojave:         "f725ef8f46eaa5207b905aab388b82683e86f6d24a48b416229415c783ce750c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b3a41cb6685e0938972728d21a8e4f6caa017f799021ba346c18e5ac7c3962d"
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
