class Pulumi < Formula
  desc "Cloud native development platform"
  homepage "https://pulumi.io/"
  url "https://github.com/pulumi/pulumi.git",
      :tag      => "v1.10.0",
      :revision => "5df00f830342e6a1670f109a5f5c171ef7345e4b"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f3f9a3732b62451cafa41870606980530907dd381248fd7b193b2095e6a917d" => :catalina
    sha256 "a767138d9302f9617005240f751d7736bb9077828627c0895cfb8dc8871e0f2a" => :mojave
    sha256 "43064db803d65615c94e889a901bbb9fe19679b116f423cb36f1a1e33a436031" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"src/github.com/pulumi/pulumi"
    dir.install buildpath.children

    cd dir do
      system "go", "mod", "vendor"
      system "make", "dist"
      bin.install Dir["#{buildpath}/bin/*"]
      prefix.install_metafiles

      # Install bash completion
      output = Utils.popen_read("#{bin}/pulumi gen-completion bash")
      (bash_completion/"pulumi").write output

      # Install zsh completion
      output = Utils.popen_read("#{bin}/pulumi gen-completion zsh")
      (zsh_completion/"_pulumi").write output
    end
  end

  test do
    ENV["PULUMI_ACCESS_TOKEN"] = "local://"
    ENV["PULUMI_TEMPLATE_PATH"] = testpath/"templates"
    system "#{bin}/pulumi", "new", "aws-typescript", "--generate-only",
                                                     "--force", "-y"
    assert_predicate testpath/"Pulumi.yaml", :exist?, "Project was not created"
  end
end
