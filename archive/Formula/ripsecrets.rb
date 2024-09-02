class Ripsecrets < Formula
  desc "Prevent committing secret keys into your source code"
  homepage "https://github.com/sirwart/ripsecrets"
  url "https://github.com/sirwart/ripsecrets/archive/v0.1.5.tar.gz"
  sha256 "1e3d36b3892d241dfd5e9abd86ddb47f22e6837b89cf9ee44989d6c1271dda2b"
  license "MIT"
  head "https://github.com/sirwart/ripsecrets.git", branch: "main"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ripsecrets"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "d78317b279671e3dc35292e7385f7076e7dd7a8f9872fea54b5edfda9810577a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # Generate a real-looking key
    keyspace = "A".upto("Z").to_a + "a".upto("z").to_a + "0".upto("9").to_a + ["_"]
    fake_key = Array.new(36).map { keyspace.sample }
    # but mark it as allowed to test more of the program
    (testpath/"test.txt").write("ghp_#{fake_key.join} # pragma: allowlist secret")

    system "#{bin}/ripsecrets", (testpath/"test.txt")
  end
end
