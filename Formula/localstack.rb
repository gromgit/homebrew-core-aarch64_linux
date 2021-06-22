class Localstack < Formula
  include Language::Python::Virtualenv

  desc "Fully functional local AWS cloud stack"
  homepage "https://github.com/localstack/localstack"
  url "https://files.pythonhosted.org/packages/a6/af/66c22bc14d0312b7dc6cc9866ef0f7daa5eddf87b8773a98dbcbf651a8d8/localstack-0.12.13.tar.gz"
  sha256 "efe0fb8a646f1263ae0e798fc0d1c4323dd2c99b7aaf62f60e826daa1674af68"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "184391305454aa3d9f91c151b39b3e112ed73e873ba28c2f09ee4ab68a987cc5"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a90fa03eefc758943354373c00c1cd6003dc189d30bbc2e5469b1ec8b05b42a"
    sha256 cellar: :any_skip_relocation, catalina:      "46a4b8a256204e7072a5bb0ac6b876ecfe39e42e6451504e0d31dd553e3046a8"
    sha256 cellar: :any_skip_relocation, mojave:        "36657539f6342b5a42af240474a9229014469622ffe79de3e59e49b9e4be3c96"
  end

  depends_on "docker" => :test
  depends_on "python@3.9"
  depends_on "six"

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/cd/16/90930985c3f2db2a8d412f6f05b68c80ee7417d8a630c27f94bb032131c1/boto3-1.17.98.tar.gz"
    sha256 "fccfa81cda69bb2317ed97e7149d7d84d19e6ec3bfbe3f721139e7ac0c407c73"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/28/f4/3dc9e36d0b73341f14a5112561f7540fd76f0a692c7dcc83a3be5d7436de/botocore-1.20.98.tar.gz"
    sha256 "b2a49de4ee04b690142c8e7240f0f5758e3f7673dd39cf398efe893bf5e11c3f"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/6d/78/f8db8d57f520a54f0b8a438319c342c61c22759d8f9a1cd2e2180b5e5ea9/certifi-2021.5.30.tar.gz"
    sha256 "2bbf76fd432960138b3ef6dda3dde0544f27cbf8546c458e60baf371917ba9ee"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/ee/2d/9cdc2b527e127b4c9db64b86647d567985940ac3698eeabc7ffaccb4ea61/chardet-4.0.0.tar.gz"
    sha256 "0d6f53a15db4120f2b08c94f11e7d93d2c911ee118b6b30a04ec3ee8310179fa"
  end

  resource "dnslib" do
    url "https://files.pythonhosted.org/packages/46/fa/8aa9993017d381cff0908ef72c0e339733709e167557fbfb73eec4c2c9ed/dnslib-0.9.16.tar.gz"
    sha256 "2d66b43d563d60c469117c8cb615843e7d05bf8fb2e6cb00a637281d26b7ec7d"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/ec/c5/14bcd63cb6d06092a004793399ec395405edf97c2301dfdc146dfbd5beed/dnspython-1.16.0.zip"
    sha256 "36c5e8e38d4369a08b6780b7f27d790a292b2b08eea01607865bf0936c558e01"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/85/f1/eab86c0058d2195ec084dd200c3e4179871e13e4f38f17ff3f6c7dee3c56/dulwich-0.20.23.tar.gz"
    sha256 "402e56b5c07f040479d1188e5c2f406e2c006aa3943080155d4c6d05e5fca865"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ea/b7/e0e3c1c467636186c39925827be42f16fee389dc404ac29e930e9136be70/idna-2.10.tar.gz"
    sha256 "b307872f855b18632ce0c21c5e45be78c0ea7ae4c15c828c20788b26921eb3f6"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/3c/56/3f325b1eef9791759784aa5046a8f6a1aff8f7c898a2e34506771d3b99d8/jmespath-0.10.0.tar.gz"
    sha256 "b85d0567b8666149a93172712e68920734333c0ce7e89b78b3e987f71e5ed4f9"
  end

  resource "localstack-client" do
    url "https://files.pythonhosted.org/packages/9f/68/1f6c4aeac934363c8cf3732d69c530bdfbe85f40ef0d6d1573d54a86c8ea/localstack-client-1.20.tar.gz"
    sha256 "7f147caede58b758271106fcbb58161ed517959fb75b522e97fa848697755eb6"
  end

  resource "localstack-ext" do
    url "https://files.pythonhosted.org/packages/71/2a/fc149ed4847a5e2b20ebd4df4cacc53fd4b6a27046bb829c710cbc325697/localstack-ext-0.12.10.7.tar.gz"
    sha256 "cfa288d71f486a1947405af81506db12914450950cda1f05317911fe6dab770e"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72/pyaes-1.6.1.tar.gz"
    sha256 "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/be/ed/5bbc91f03fa4c839c4c7360375da77f9659af5f7086b7a7bdda65771c8e0/python-dateutil-2.8.1.tar.gz"
    sha256 "73ebfe9dbf22e832286dafa60473e4cd239f8592f699aa5adaf10050e6e1823c"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/6b/47/c14abc08432ab22dc18b9892252efaf005ab44066de871e72a38d6af464b/requests-2.25.1.tar.gz"
    sha256 "27973dd4a904a4f13b263a19c866c13b92a39ed1c964655f025f3f8d3d75b804"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/27/90/f467e516a845cf378d85f0a51913c642e31e2570eb64b352c4dc4c6cbfc7/s3transfer-0.4.2.tar.gz"
    sha256 "cb022f4b16551edebbb31a377d3f09600dbada7363d8c5db7976e7f47732e1b2"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/94/40/c396b5b212533716949a4d295f91a4c100d51ba95ea9e2d96b6b0517e5a5/urllib3-1.26.5.tar.gz"
    sha256 "a7acd0977125325f516bda9735fa7142b909a8d01e8b2e4c8108d0984e6e0098"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    ENV["DOCKER_HOST"] = "unix://" + (testpath/"invalid.sock")

    assert_match version.to_s, shell_output("#{bin}/localstack --version")

    output = shell_output("#{bin}/localstack start --docker", 125)

    assert_match "Starting local dev environment", output
    assert_match "Cannot connect to the Docker daemon", output
  end
end
