class Dprint < Formula
  desc "Pluggable and configurable code formatting platform written in Rust"
  homepage "https://dprint.dev/"
  url "https://github.com/dprint/dprint/archive/0.11.0.tar.gz"
  sha256 "beb0e57cf3db632a2f2704b7e0cfca49be5c2d4428d19fa10b62b9dfd6d4d210"
  license "MIT"
  head "https://github.com/dprint/dprint.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "77a9ea8f3e9bfbe4933a58d111f11f7a9d5354c9c431ea18e0183960e9273845" => :big_sur
    sha256 "811b611a09d890db5548facc7db914f13741e7d2de94b4f0081a0746f4f6a179" => :catalina
    sha256 "79814bd0f878870701930232ab8b3f7490cf16ae0190dd65b61ba30c810f0ba3" => :mojave
  end

  depends_on "rust" => :build

  def install
    # replace `--path` arg with `./crates/dprint`
    args = std_cargo_args.map { |s| s == "." ? "./crates/dprint" : s }
    system "cargo", "install", *args
  end

  test do
    (testpath/".dprintrc.json").write <<~EOS
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
          "https://plugins.dprint.dev/typescript-0.34.0.wasm",
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
