class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/v0.11.1.tar.gz"
  sha256 "2d80f0243d70a3563c48644dd3567519c32a733fb5d20f1161fd5d9f8e6e9146"
  license "MIT"
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f80039197a8a9d8f8e876ad5509307b689edbe0c00a2aafbe46ff590beb8feef"
    sha256 cellar: :any,                 arm64_big_sur:  "611b0bbb483b79d72954a86674b3f6d4b4e0ac7db44abdc92771493e15c119d2"
    sha256 cellar: :any,                 monterey:       "e27380689ab5bdbfa851492ed3d05af11df17d354864b557b9ff4eba8e54b134"
    sha256 cellar: :any,                 big_sur:        "3c64483d6585739b2ec4eefc71016bd2d66a8e074c831f616b0ac272ae6854ee"
    sha256 cellar: :any,                 catalina:       "3b09391c389cc3abb02a03460beeb1aa1cdce35df55e98c8c2319eefc3ef94f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29491160f0ff4e38fad970d64f63b7b815a4332ff27d70590d531066cbbc5cc5"
  end

  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
      EOS

      (crate/"lib.rs").write "use libc;"

      output = shell_output("cargo outdated 2>&1")
      # libc 0.1 is outdated
      assert_match "libc", output
    end
  end
end
