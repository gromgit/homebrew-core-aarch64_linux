class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v1.1.0.tar.gz"
  sha256 "c9a72e2267b95e39033e845961ad45675c9f0d86080b138c6a2fbf2a5d3428d1"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d1d95d2ac2e68f87f68995e6b80a719c5c842115da4406b77976ad6bf5a03fb" => :big_sur
    sha256 "fa68695a4ee1664ce370c49ae845be25cb602e33d62ceccc1607fe09a1a9d233" => :catalina
    sha256 "ec73e1021f683a08468b1827358338bd8720b8099ec2e5c5a4424b738b45e396" => :mojave
    sha256 "178507ed940ab39575ce0adbee3f4285905641f095c82589659fef578d46804e" => :high_sierra
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
