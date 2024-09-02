class Geph2 < Formula
  desc "Modular Internet censorship circumvention system"
  homepage "https://geph.io"
  url "https://github.com/geph-official/geph2/archive/v0.22.5.tar.gz"
  sha256 "4afca74d97c890061d34c8885258d6f4a48c63e69c7e8b56719fdae68c4f306b"
  license "GPL-3.0-only"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/geph2"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "6f31cbd9a55203002b76e40a433e52b4035fa60ce9d9fcd30cfefec71367b776"
  end

  # Geph has been rewritten in Rust: https://github.com/geph-official/geph4
  deprecate! date: "2020-04-24", because: :repo_archived

  depends_on "go" => :build

  def install
    bin_path = buildpath/"src/github.com/geph-official/geph2"
    bin_path.install Dir["*"]
    cd bin_path/"cmd/geph-client" do
      ENV["CGO_ENABLED"] = "0"
      system "go", "build", "-o",
       bin/"geph-client", "-v", "-trimpath"
    end
  end

  test do
    assert_match "username = homebrew", shell_output("#{bin}/geph-client -username homebrew -dumpflags")
  end
end
