class Devspace < Formula
  desc "CLI helps develop/deploy/debug apps with Docker and k8s"
  homepage "https://devspace.cloud/docs"
  url "https://github.com/devspace-cloud/devspace.git",
    tag:      "v5.1.1",
    revision: "defb68df4a93d9e3fd953bdd0c171efd7de6e496"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1eb51440d17c1f60fd6b60c40dcfcf2f27951112eb34dc9afdb80a2a9f57976d" => :catalina
    sha256 "b501519e263e8c4477531a3b8a30dcab0e8171353b86b515615f76d0b387a8d0" => :mojave
    sha256 "798ee272d10725acd8d607c267774cea980ad961ce8f4a1252df3a2621b1ee70" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "kubernetes-cli"

  def install
    system "go", "build", "-ldflags",
    "-s -w -X main.commitHash=#{stable.specs[:revision]} -X main.version=#{stable.specs[:tag]}", *std_go_args
  end

  test do
    help_output = "DevSpace accelerates developing, deploying and debugging applications with Docker and Kubernetes."
    assert_match help_output, shell_output("#{bin}/devspace help")

    init_help_output = "Initializes a new devspace project"
    assert_match init_help_output, shell_output("#{bin}/devspace init --help")
  end
end
