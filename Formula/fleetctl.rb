class Fleetctl < Formula
  desc "Distributed init system"
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet.git",
      tag:      "v1.0.0",
      revision: "b8127afc06e3e41089a7fc9c3d7d80c9925f4dab"
  license "Apache-2.0"
  head "https://github.com/coreos/fleet.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/fleetctl"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "16cf481b0dbcd61fc1cfda647aac72af6af8d04949cdae5a9fc030b3db945807"
  end

  # "CoreOS recommends Kubernetes for all clustering needs":
  # https://coreos.com/blog/migrating-from-fleet-to-kubernetes.html
  deprecate! date: "2020-04-15", because: :repo_archived

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    system "./build"
    bin.install "bin/fleetctl"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/fleetctl --version")
  end
end
