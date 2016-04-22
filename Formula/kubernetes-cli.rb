class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "http://kubernetes.io/"
  head "https://github.com/kubernetes/kubernetes.git"

  stable do
    url "https://github.com/kubernetes/kubernetes/archive/v1.2.3.tar.gz"
    sha256 "542db5eb9f635aae53dc4055c778101e1192f34d04549505bd2ada8dec0d837c"
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3048d47f8f76cf3a7810ddf32fa8033de19e176cc6580517baac0c9cf1cd2f91" => :el_capitan
    sha256 "efc627b0b7f8ec3a303c12f7c744a865e0f02bb8f566f196ba2a1b6174a81b81" => :yosemite
    sha256 "fdff09be5f09b4963473687269166ebce01bd738ea90fb65881b8ffced5f6559" => :mavericks
  end

  devel do
    url "https://github.com/kubernetes/kubernetes/archive/v1.3.0-alpha.2.tar.gz"
    sha256 "a0d865e294a65cce54ab0ed3e5d04c574db4fca361e155f1e5f9f773ad699f5b"
    version "1.3.0-alpha.2"
  end

  depends_on "go" => :build

  def install
    arch = MacOS.prefer_64_bit? ? "amd64" : "x86"

    system "make", "all", "WHAT=cmd/kubectl", "GOFLAGS=-v"

    dir = "_output/local/bin/darwin/#{arch}"
    bin.install "#{dir}/kubectl"
    bash_completion.install "contrib/completions/bash/kubectl"
  end

  test do
    assert_match /^kubectl controls the Kubernetes cluster manager./, shell_output("#{bin}/kubectl 2>&1", 0)
  end
end
