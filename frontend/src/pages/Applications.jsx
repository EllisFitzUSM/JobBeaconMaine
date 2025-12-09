import { AuthProvider } from "../AuthContext";

export default function Applications() {
    const { userId } = useAuth();
    return (
        <AuthProvider>
            <div className="applications-page">
                <h1>Your Applications</h1>
                <Application />
                <Application />
                <Application />
            </div>
        </AuthProvider>
    )

}