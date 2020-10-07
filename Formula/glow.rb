class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v1.0.0.tar.gz"
  sha256 "15e1ec195a11ff36c5d322d193961a39eed22626e376638eb262ec29fb56eae3"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4473c3ff6cb0e1e991a793018706899c1a673629b5a6f8de6aeb0bb5b85cdaa6" => :catalina
    sha256 "802e98f0e30a74b7e3af8fe6a39145ee02df42e0178fbd5c36e2b7ad1716a364" => :mojave
    sha256 "240ea2dc2ac1699c821e32c99c4906eb607f1c28660ab188c8c4e034f9221c4d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w", "-trimpath", "-o", bin/name
  end

  test do
    (testpath/"test.md").write <<~EOS
      # header

      **bold**

      ```
      code
      ```
    EOS
    assert_match "# header", shell_output("#{bin}/glow test.md")
  end
end
