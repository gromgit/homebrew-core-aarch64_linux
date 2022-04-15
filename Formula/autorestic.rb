class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.6.2.tar.gz"
  sha256 "3ad6e2e9bb7ad8b48c1f4405995ed757cb3d6707ec141e12969b2f14e8240459"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4268c0bc50cb4e0cbe9e1ad75764aa821fcf295fa3feb803ef06a1686e4c984c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf08a13a13117ce40d6831a39f1c27e4a25b3c738b6b32f82e3c6b399bca603c"
    sha256 cellar: :any_skip_relocation, monterey:       "cbe2512f547764d8ab644a67cd361e9721f586a1c7a877bb433fc5446cfa562c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c06e236a72b7b56684be21614211c192a5a390c570127f0aa7728cba3cd58f9f"
    sha256 cellar: :any_skip_relocation, catalina:       "5b228422a7c1234e72cecc12e876524a710142105c2d928f209ceb93d01e982b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "455bed114c0ff21c2890c7cd02e40be5b91d911123a1e67bd5d64046dc9991a5"
  end

  depends_on "go" => :build
  depends_on "restic"

  def install
    system "go", "build", *std_go_args, "./main.go"
    (bash_completion/"autorestic").write Utils.safe_popen_read("#{bin}/autorestic", "completion", "bash")
    (zsh_completion/"_autorestic").write Utils.safe_popen_read("#{bin}/autorestic", "completion", "zsh")
    (fish_completion/"autorestic.fish").write Utils.safe_popen_read("#{bin}/autorestic", "completion", "fish")
  end

  test do
    require "yaml"
    config = {
      "locations" => { "foo" => { "from" => "repo", "to" => ["bar"] } },
      "backends"  => { "bar" => { "type" => "local", "key" => "secret", "path" => "data" } },
    }
    config["version"] = 2
    File.write(testpath/".autorestic.yml", config.to_yaml)
    (testpath/"repo"/"test.txt").write("This is a testfile")
    system "#{bin}/autorestic", "check"
    system "#{bin}/autorestic", "backup", "-a"
    system "#{bin}/autorestic", "restore", "-l", "foo", "--to", "restore"
    assert compare_file testpath/"repo"/"test.txt", testpath/"restore"/testpath/"repo"/"test.txt"
  end
end
