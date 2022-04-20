class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.26.0.tar.gz"
  sha256 "547dcbd23e30de1ccf0d7aba1d4e39af773fb2dcc17b01e37af958d90ad69a39"
  license "MIT"
  head "https://github.com/dprint/dprint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a21e8a4c48f01064ae605cc5099d58a78058f195f485bd30cdc9d5a1bd9da644"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a8dd45bf5f2c175cd35256bfd26223d659b55cac46b6598d4fec288455433eb4"
    sha256 cellar: :any_skip_relocation, monterey:       "a1e00f4f496e328c99fd39b73b95afd31b7412b6dda3d819ee4f755b1ce848c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c442917fc3eb84f8ba2864e32af0d75e1fbdc465884b9026d01bef3b5a455574"
    sha256 cellar: :any_skip_relocation, catalina:       "652fd466f2a29c809a9855304d36c0f023bd8068d20fe441030ed10f17910344"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55805db5d6350c4d41f5032387ce4fb3e9e63d07456475239fadba651ec9e23c"
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
