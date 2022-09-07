class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.27.1.tar.gz"
  sha256 "2a8aa1111149d825ced8809ff41852c9ef5e43ba5e000557fdb40f5ee73df2eb"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "959d40c05da114d18215f3b30cb5ba5fae72800d60218c33cb08a6b1478d1c2d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ebd330c9f7b9950de048e70c0824f7165ac1c5465b0094ca3fc1dcc7692ba8d"
    sha256 cellar: :any_skip_relocation, monterey:       "5192c999512aa1ab27cbbb80ad7273f911a8724e97a99eaf07522381861176d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "978268d30094852dca3c4e53632e92d1cc6f6b49d530d99de10bfcf18600c3a1"
    sha256 cellar: :any_skip_relocation, catalina:       "071f61fca491055d9c6f88d90d910e974e1ae99bf751f427eb56fe177f4cffb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f93d666abf5a45b697f411cfb653e7f60cf0981b0898b7777acf1bd80e603d87"
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
