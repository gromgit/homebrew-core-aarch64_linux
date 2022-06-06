class Glow < Formula
  desc "Render markdown on the CLI"
  homepage "https://github.com/charmbracelet/glow"
  url "https://github.com/charmbracelet/glow/archive/v1.4.1.tar.gz"
  sha256 "ff6dfd7568f0bac5144ffa3a429ed956dcbdb531487ef6e38ac61365322c9601"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/glow"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "69bcf4925481efe684252dd49141242d9db627d23b5805f4562c187db0a6c920"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}", "-trimpath", "-o", bin/name
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
