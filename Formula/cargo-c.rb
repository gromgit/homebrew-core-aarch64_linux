class CargoC < Formula
  desc "Helper program to build and install c-like libraries"
  homepage "https://github.com/lu-zero/cargo-c"
  url "https://github.com/lu-zero/cargo-c/archive/v0.9.0.tar.gz"
  sha256 "431824dee0b048877c625c5d61f03a60d40550711df25006e0543c5ec3f1e234"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b54007b8adf4a6ba65e807db60c898eb5163fddcb1a364ca4c084bdd2aebeb2b"
    sha256 cellar: :any, big_sur:       "089b0de0b2ae34e7b2573378630382e6d2f39426f6255c1512893fe88b93c790"
    sha256 cellar: :any, catalina:      "383f80140b1225b603ac788567a4a4bb91d4c8fa4e225e2df871c1e96da4028d"
    sha256 cellar: :any, mojave:        "8d5ac533ae6d9d667b68a085d941380a4facea63b068e796ff45683b23313785"
  end

  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    cargo_error = "could not find `Cargo.toml`"
    assert_match cargo_error, shell_output("#{bin}/cargo-cinstall cinstall 2>&1", 1)
    assert_match cargo_error, shell_output("#{bin}/cargo-cbuild cbuild 2>&1", 1)
  end
end
