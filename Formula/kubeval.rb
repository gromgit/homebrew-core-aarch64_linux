class Kubeval < Formula
  desc "Validate Kubernetes configuration files, supports multiple Kubernetes versions"
  homepage "https://www.kubeval.com/"
  url "https://github.com/instrumenta/kubeval.git",
      tag:      "v0.16.1",
      revision: "f5dba6b486fa18b9179b91e15eb6f2b0f7a5a69e"
  license "Apache-2.0"
  head "https://github.com/instrumenta/kubeval.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/kubeval"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "50362326082579c805b1219c2316d981d6f8997b811115aeda30c8f949fe4717"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    pkgshare.install "fixtures"
  end

  test do
    system bin/"kubeval", pkgshare/"fixtures/valid.yaml"

    assert_match "spec.replicas: Invalid type. Expected: [integer,null], given: string",
      shell_output(bin/"kubeval #{pkgshare}/fixtures/invalid.yaml 2>&1", 1)

    assert_match version.to_s, shell_output(bin/"kubeval --version")
  end
end
