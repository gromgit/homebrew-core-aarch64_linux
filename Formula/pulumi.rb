class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v3.10.3",
      revision: "d8ebde1590088a21216329b429a83f7b39b512ef"
  license "Apache-2.0"
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "840de4549e991543c3da2ccf90f53c23d1141b843f79889df9095a9ecb3369bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "0b1903c27f923c57241e5280b5f058a76b16b98f7f23303ed8068993fed5d9be"
    sha256 cellar: :any_skip_relocation, catalina:      "847f800d6ab137e0576af574f497ef0f0a391b03d058dfaed8e42b8da125a5da"
    sha256 cellar: :any_skip_relocation, mojave:        "71f4d8e1d4128d7f2d7328a1cc114d33040ec1db20eac3895cac484b789376ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "68665e7c6764f7025ecb96946c5a0b39dcd4fa3a38be4927ff6dfc195e0382eb"
  end

  depends_on "go" => :build

  def install
    cd "./sdk" do
      system "go", "mod", "download"
    end
    cd "./pkg" do
      system "go", "mod", "download"
    end

    system "make", "brew"

    bin.install Dir["#{ENV["GOPATH"]}/bin/pulumi*"]

    # Install shell completions
    (bash_completion/"pulumi.bash").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "bash")
    (zsh_completion/"_pulumi").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "zsh")
    (fish_completion/"pulumi.fish").write Utils.safe_popen_read(bin/"pulumi", "gen-completion", "fish")
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
