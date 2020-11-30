class Vale < Formula
  desc "Syntax-aware linter for prose"
  homepage "https://errata-ai.github.io/vale/"
  url "https://github.com/errata-ai/vale/archive/v2.6.4.tar.gz"
  sha256 "f68e8340c4ad40abfb3d9bfb0421c675fd4e2f07d57fe01834d7a80db55c08b3"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "a2967f35b98de02e0b187c472e7363d2f051afe800688ed2c836aa510008b9df" => :big_sur
    sha256 "7bfe867b7d7f214fe8295895b5847d627916018fcad42e295d7e77b22ee30c21" => :catalina
    sha256 "784eace57f70b174063890e65793a86265e955213be840a24ccc54bcdc59f3da" => :mojave
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
