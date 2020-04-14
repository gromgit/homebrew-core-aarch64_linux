class Opa < Formula
  desc "Open source, general-purpose policy engine"
  homepage "https://www.openpolicyagent.org"
  url "https://github.com/open-policy-agent/opa/archive/v0.19.1.tar.gz"
  sha256 "6edbc3d327ce401508b10f4969554cdc1cea73fd00037b42bd21af87a59cdb63"
  head "https://github.com/open-policy-agent/opa.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a4b8bb29e63c3e28919532204f75fab903eecd8b9aa4c28aaf375f5bea76a74" => :catalina
    sha256 "a00626bf9f394ad59226542003a0ba480a25beecfaaa6dc16836060a0a9aa69f" => :mojave
    sha256 "8bb66409b00abfa6fba1c517301023346fbb491f797963623e32a924a63bd56c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"opa", "-trimpath", "-ldflags",
                 "-X github.com/open-policy-agent/opa/version.Version=#{version}"
    system "./build/gen-man.sh", "man1"
    man.install "man1"
    prefix.install_metafiles
  end

  test do
    output = shell_output("#{bin}/opa eval -f pretty '[x, 2] = [1, y]' 2>&1")
    assert_equal "+---+---+\n| x | y |\n+---+---+\n| 1 | 2 |\n+---+---+\n", output
    assert_match "Version: #{version}", shell_output("#{bin}/opa version 2>&1")
  end
end
