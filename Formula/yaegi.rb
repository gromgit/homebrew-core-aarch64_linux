class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/containous/yaegi"
  url "https://github.com/containous/yaegi/archive/v0.8.12.tar.gz"
  sha256 "07b2948ec00fc1ffd2f091f59dbf5d2df500686a79d53a99c3985eab7bbfbdad"
  license "Apache-2.0"
  head "https://github.com/containous/yaegi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ed16046653b93e18b4d692493f8dc1757cf6f331a14e8ceb020a2818ac9ff412" => :catalina
    sha256 "e69ca038967da39477d1bcb67c757216908a3a2f156ef1f21674fe6197276899" => :mojave
    sha256 "738ef2f625c085e272b852e62f839ba3111c01fa52f8064ac8148208104fd91d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "cmd/yaegi/yaegi.go"
    prefix.install_metafiles
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
