class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.30.2.tar.gz"
  sha256 "32ce2423906bfb89fe52f7822bd92861c10dabe8ea82031d0ca314f04fdc44ea"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "706a22343fb7bd6379d94805ee8623f7df772d7cb81e9541e51e39ceb02b3ad9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b07eff7af89aa4f48a9eedcb2d78ea37c811d4b67a0d2be66d5626030adbd7f0"
    sha256 cellar: :any_skip_relocation, monterey:       "b8b4cfb74a56b9c87e5cd6c9e4b28535dedfc77e5ee27118cb674244d49f8b38"
    sha256 cellar: :any_skip_relocation, big_sur:        "736527d51a44deafb10167e6b49846cf71ab89ebd7d8ac376dc32a8e07a53867"
    sha256 cellar: :any_skip_relocation, catalina:       "2b0a23776372f3cf157da3a16c5e745a64adb18a022190989b6899c8f8328d5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fed15edc2bd562f650fa8c5cdf5154cf2d17c44d783e88b35b3b984ef8ef8591"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/dprint")
  end

  test do
    (testpath/"dprint.json").write <<~EOS
      {
        "$schema": "https://dprint.dev/schemas/v0.json",
        "projectType": "openSource",
        "incremental": true,
        "typescript": {
        },
        "json": {
        },
        "markdown": {
        },
        "rustfmt": {
        },
        "includes": ["**/*.{ts,tsx,js,jsx,json,md,rs}"],
        "excludes": [
          "**/node_modules",
          "**/*-lock.json",
          "**/target"
        ],
        "plugins": [
          "https://plugins.dprint.dev/typescript-0.44.1.wasm",
          "https://plugins.dprint.dev/json-0.7.2.wasm",
          "https://plugins.dprint.dev/markdown-0.4.3.wasm",
          "https://plugins.dprint.dev/rustfmt-0.3.0.wasm"
        ]
      }
    EOS

    (testpath/"test.js").write("const arr = [1,2];")
    system bin/"dprint", "fmt", testpath/"test.js"
    assert_match "const arr = [1, 2];", File.read(testpath/"test.js")

    assert_match "dprint #{version}", shell_output("#{bin}/dprint --version")
  end
end
