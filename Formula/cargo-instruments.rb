class CargoInstruments < Formula
  desc "Easily generate Instruments traces for your rust crate"
  homepage "https://github.com/cmyr/cargo-instruments"
  url "https://github.com/cmyr/cargo-instruments/archive/v0.4.7.tar.gz"
  sha256 "05827aae15603ab8a3538a5c9df5d3571f8d28d9b5d52c50728fbc5b6f6bbfd6"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_monterey: "40389e851981cde7db8ca32e5f9f0f5e75a572113663b2b9e8cd5ce0a34bddbc"
    sha256 cellar: :any, arm64_big_sur:  "0d47e7cac4a7581b0f3736e2a18b8810669d04e631faf2e2da48a0a787f6dfd7"
    sha256 cellar: :any, monterey:       "f880863126144f140ce2336e92b4f033bfae8208be6b0944cdc0d49996ee7166"
    sha256 cellar: :any, big_sur:        "f615cbd7dff0fd995803cd071e6640f5cee10d9f8b2a076c5b79b4fb2e9fac53"
    sha256 cellar: :any, catalina:       "216253aed310e75e422d5816a1ec815e7321d82edbc1bcab987b19a172045bfe"
  end

  depends_on "rust" => :build
  depends_on :macos
  depends_on "openssl@1.1"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output "#{bin}/cargo-instruments instruments", 1
    assert_match output, "could not find `Cargo.toml` in `#{Dir.pwd}` or any parent directory"
  end
end
