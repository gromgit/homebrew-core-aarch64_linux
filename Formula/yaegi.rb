class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/v0.11.3.tar.gz"
  sha256 "46e73955145cd829e41a906677edfcd78846862ca0274770dd4668dda2a949c1"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/yaegi"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "b4a3b8669613decd2e6f72fa392fbae578816e423788e78508ce02a9bd47b9ff"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
