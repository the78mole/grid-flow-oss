export default function Home() {
  return (
    <main className="min-h-screen p-8">
      <div className="max-w-6xl mx-auto">
        <header className="mb-8">
          <h1 className="text-4xl font-bold mb-2">GridFlow</h1>
          <p className="text-xl text-gray-600">
            PV Registration System - VDE-AR-N 4105
          </p>
        </header>

        <div className="grid gap-6 md:grid-cols-2 lg:grid-cols-3">
          <div className="p-6 border rounded-lg shadow-sm hover:shadow-md transition-shadow">
            <h2 className="text-2xl font-semibold mb-2">🔐 Authentication</h2>
            <p className="text-gray-600 mb-4">
              Login with eID or Passkey (WebAuthn)
            </p>
            <a
              href="/auth/login"
              className="inline-block px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700"
            >
              Sign In
            </a>
          </div>

          <div className="p-6 border rounded-lg shadow-sm hover:shadow-md transition-shadow">
            <h2 className="text-2xl font-semibold mb-2">📋 New Registration</h2>
            <p className="text-gray-600 mb-4">
              Start a new PV system registration
            </p>
            <a
              href="/registration/new"
              className="inline-block px-4 py-2 bg-green-600 text-white rounded hover:bg-green-700"
            >
              Start Process
            </a>
          </div>

          <div className="p-6 border rounded-lg shadow-sm hover:shadow-md transition-shadow">
            <h2 className="text-2xl font-semibold mb-2">🤖 AI Analysis</h2>
            <p className="text-gray-600 mb-4">
              Upload meter cabinet images for AI validation
            </p>
            <a
              href="/analysis"
              className="inline-block px-4 py-2 bg-purple-600 text-white rounded hover:bg-purple-700"
            >
              Analyze
            </a>
          </div>

          <div className="p-6 border rounded-lg shadow-sm hover:shadow-md transition-shadow">
            <h2 className="text-2xl font-semibold mb-2">⚙️ BPMN Workflows</h2>
            <p className="text-gray-600 mb-4">
              View and manage BPMN process definitions
            </p>
            <a
              href="/workflows"
              className="inline-block px-4 py-2 bg-orange-600 text-white rounded hover:bg-orange-700"
            >
              View Workflows
            </a>
          </div>

          <div className="p-6 border rounded-lg shadow-sm hover:shadow-md transition-shadow">
            <h2 className="text-2xl font-semibold mb-2">📊 Dashboard</h2>
            <p className="text-gray-600 mb-4">
              View your registration status and history
            </p>
            <a
              href="/dashboard"
              className="inline-block px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700"
            >
              Dashboard
            </a>
          </div>

          <div className="p-6 border rounded-lg shadow-sm hover:shadow-md transition-shadow">
            <h2 className="text-2xl font-semibold mb-2">📚 Documentation</h2>
            <p className="text-gray-600 mb-4">
              API docs and integration guides
            </p>
            <a
              href="http://localhost:8000/docs"
              target="_blank"
              rel="noopener noreferrer"
              className="inline-block px-4 py-2 bg-gray-600 text-white rounded hover:bg-gray-700"
            >
              API Docs
            </a>
          </div>
        </div>

        <footer className="mt-12 pt-8 border-t text-center text-gray-600">
          <p>
            Built with SpiffWorkflow, FastAPI, PyTorch, and Next.js
          </p>
          <p className="mt-2">
            Features eID/Passkey authentication and AI-based meter cabinet validation
          </p>
        </footer>
      </div>
    </main>
  )
}
