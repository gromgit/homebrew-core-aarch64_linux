class Ttdl < Formula
  desc "Terminal Todo List Manager"
  homepage "https://github.com/VladimirMarkelov/ttdl"
  url "https://github.com/VladimirMarkelov/ttdl/archive/refs/tags/v3.4.4.tar.gz"
  sha256 "c20608c20233aa4495eabed631e70448e307e8ab0b006f328d6e72d3278311b5"
  license "MIT"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/ttdl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "62fff6f7888eb47234f2034773be140b92900ab0c2fa4545bfd43ac75cee5277"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Added todo", shell_output("#{bin}/ttdl 'add readme due:tomorrow'")
    assert_predicate testpath/"todo.txt", :exist?
    assert_match "add readme", shell_output("#{bin}/ttdl list")
  end
end
