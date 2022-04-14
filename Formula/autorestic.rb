class Autorestic < Formula
  desc "High level CLI utility for restic"
  homepage "https://autorestic.vercel.app/"
  url "https://github.com/cupcakearmy/autorestic/archive/v1.6.1.tar.gz"
  sha256 "61406b53e4351913f9c5ec2a829d64e319e14e40b86b5d075301dcc3cead27da"
  license "Apache-2.0"
  head "https://github.com/cupcakearmy/autorestic.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0fcb4f9547b3160f24c9f8547198146644ac32e554832c08c003384d306b7c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1e28c5c01c3811971b3ffe0b6836ea170b9b9ab6d6bb6ca12a21bb451913b54"
    sha256 cellar: :any_skip_relocation, monterey:       "d67f0223171d6073badf595b5a3a7a6f02d33f8d4902be808655924fe9ffeebb"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ddea95ab3f712184c8a218b05fcc3f4346c3379ce7732e40ca2c90d9c37caed"
    sha256 cellar: :any_skip_relocation, catalina:       "010267809ce677b676fae22766e22943489713c0ffbb499e2e472b21e1f988f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f425605bc2759450f6529f19a94f39baf9ef63e21eef41241c686d7b2cc27df"
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
