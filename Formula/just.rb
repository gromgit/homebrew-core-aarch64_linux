class Just < Formula
  desc "Handy way to save and run project-specific commands"
  homepage "https://github.com/casey/just"
  url "https://github.com/casey/just/archive/v0.7.2.tar.gz"
  sha256 "85c2992bc0c24940842db8006aca8d0ae5f487a60133212066d5da57bdde6ea2"
  license "CC0-1.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e182e24f45d8c3487fed1e3b6423da653177b8d8e92314940878096b4a6008f4" => :catalina
    sha256 "b758b693671a3454a8acd7b9788ba307e1ba66d4f597e818c7416f7ea11b239d" => :mojave
    sha256 "edc1488597b39146206ae58c3f49e6a37c902b9f61d2760960da2ac652ed0785" => :high_sierra
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
