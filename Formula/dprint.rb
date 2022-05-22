class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.29.0.tar.gz"
  sha256 "1852c47fbe36224ff4591f263086045d8ee7a01082cf50d41d150d131ea8562b"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bbab06d084af2ca0e9b2056a4b574a7f18706ddb3c278fa79cefb330ffd8c908"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5462ffbee3bf2fd4f709f5e830f737faa4a50572b0063add24bb485d04986b6"
    sha256 cellar: :any_skip_relocation, monterey:       "fe650636124b522b6bc6bfe21c48025c0eb4a4eddccb9646e5b6781366705782"
    sha256 cellar: :any_skip_relocation, big_sur:        "187cd437ef57b4edcc4b9766c50d2ca559eca5c64ffdb1c5c56333ecc7479462"
    sha256 cellar: :any_skip_relocation, catalina:       "578f08b6e8fb32116bc25b5357631c7d37f66aa4485502bf375544eba5124fd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cd376c81128eb384e4456e2b774474c5c074772ae114a35b0504d819bd5e5f6"
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
