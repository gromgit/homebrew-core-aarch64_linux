class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      tag:      "v2.16.2",
      revision: "58c07c52c8d4db037c284b66d432d96db6081ca9"
  license "Apache-2.0"
  revision 1
  head "https://github.com/pulumi/pulumi.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa9744c9e7567338c07efe3dcf5bb47fb37d27516156a2c1c55d80565334a155" => :big_sur
    sha256 "0eb9a1a332050a60dd88ac5bb43222d635219c42b474b70d55af338918009d17" => :arm64_big_sur
    sha256 "e8eb627bf67fbee76c541bb53b9cbbc2e9b26fdc4136b3fdc0149531a0c1125d" => :catalina
    sha256 "4e55569537a20717dc0fe81d3c38483895ea9e949492ae23ca8be0d1ae335ea6" => :mojave
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
