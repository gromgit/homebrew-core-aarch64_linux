class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.6.1.tar.gz"
  sha256 "3707b202a16bc4541cccb26316bc13b3b3853055c47a7a50e7a0e64dca33062a"

  bottle do
    cellar :any_skip_relocation
    sha256 "f059c7de861f0535890893627ea4b55460cc87b426d3b463acc0769b9dc1fbdb" => :catalina
    sha256 "bfa8b1e92a14768ac366411dd78fba441bd13843b11b8199633a0705b115128a" => :mojave
    sha256 "f29b4e5b9ad9e4ae72963956293b61b2b7c0f1d01703cc1c57f53486cd4bedce" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"justfile").write <<~EOS
      default:
        touch it-worked
    EOS
    system "#{bin}/just"
    assert_predicate testpath/"it-worked", :exist?
  end
end
