class Geph2 < Formula
  desc "Modular Internet censorship circumvention system"
  homepage "https://geph.io"
  url "https://github.com/geph-official/geph2/archive/v0.21.0.tar.gz"
  sha256 "38ab87945bdf22cb930b088539e0274281e492a2841ac620e90b912db1e0f0f1"

  bottle do
    cellar :any_skip_relocation
    sha256 "e1540b9ee25427d5dbf4514e816771991e2e3310dcdb5ff08b1ec7f63b678cfb" => :catalina
    sha256 "e1540b9ee25427d5dbf4514e816771991e2e3310dcdb5ff08b1ec7f63b678cfb" => :mojave
    sha256 "e1540b9ee25427d5dbf4514e816771991e2e3310dcdb5ff08b1ec7f63b678cfb" => :high_sierra
  end

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
    assert_match "-username", shell_output("#{bin}/geph-client -h 2>&1", 2)
  end
end
