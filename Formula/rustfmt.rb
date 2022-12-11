class Rustfmt < Formula
  desc "Format Rust code"
  homepage "https://rust-lang.github.io/rustfmt/"
  url "https://github.com/rust-lang/rustfmt/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "dc29a1c066fe4816e1400655c676d632335d667c3b0231ce344b2a7b02acc267"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/rust-lang/rustfmt.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/rustfmt"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b517d5ae155852a7dc56ae857b56d958821408c764f1d4b03381627fa1dd9ace"
  end

  depends_on "rustup-init" => :build
  depends_on "rust" => :test

  def install
    system "#{Formula["rustup-init"].bin}/rustup-init", "-qy", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    # we are using nightly because rustfmt requires nightly in order to build from source
    # pinning to nightly-2021-11-08 to avoid inconstency
    nightly_version = "nightly-2021-11-08"
    components = %w[rust-src rustc-dev llvm-tools-preview]
    system "rustup", "toolchain", "install", nightly_version
    system "rustup", "component", "add", *components, "--toolchain", nightly_version
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      system "rustfmt", "--check", "./src/main.rs"
    end
  end
end
